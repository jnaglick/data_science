# TODO 4 spaces instead of tabs
def euclidean_distance(a, b)
	raise Exception.new('euclidean_distance expects vectors of same length') if a.length != b.length
	Math.sqrt(a.zip(b).inject(0){ |sum, o| sum + ((o[0] - o[1])**2) })
end

def print_vector(v) # TODO move into TrainingVector
	v.each_slice(28).each { |pxs| 
		puts pxs.map{ |px| 
			px == 0 ? ' ' : 
				px <= 128 ? '.' : 
					px <= 192 ? '+' :
						px <= 252 ? '*' : '%'
		}.join()
	}
end

class TrainingVector
	attr_accessor :classification, :vector
	def initialize(classification, vector)
		@classification = classification
		@vector = vector
	end
end

def read_train_csv(opts = {})
	require 'csv'

	training_vectors = []
	start_read = opts[:start_read] || 0
	max_read = opts[:max_read]
	file_path = opts[:file_path] || 'train.csv'

	skip_i = -1  # first row of csv is labels we dont care about.
	read_i = 0
	CSV.foreach(file_path) do |row|
		(skip_i += 1) and next if skip_i < start_read # could optimize this out
		training_vectors << TrainingVector.new(row.shift, row.map(&:to_i))
		break if !max_read.nil? && (read_i += 1) == max_read
	end

	training_vectors
end

class KnnClassifier
	attr_accessor :training_vectors
	def initialize(training_vectors)
		@training_vectors = training_vectors
	end

	def knn(vector, k = 5) # returns {euclidean_distance: TrainingVector, ...}
		raise Exception.new('k must be odd') unless k % 2 == 1
		knn = {}

		# populate knn with first k from training_vectors
		@training_vectors.take(k).each do |training_vector|
			knn[euclidean_distance(vector, training_vector.vector)] = training_vector
		end

		max = knn.keys.max

		@training_vectors.last(@training_vectors.length - k).each do |training_vector|
			e_d = euclidean_distance(vector, training_vector.vector)
			if e_d < max
				knn[e_d] = training_vector
				knn.delete(max)
				max = knn.keys.max
			end
		end

		knn
	end

	def knn_classify(vector, k = 5) # returns {classification: knn} requires majority
		knn = knn(vector, k)
		knn.values.each do |tv| # TODO make this not dumb. im tired.
			return tv.classification if knn.values.select{|tv2|tv.classification == tv2.classification}.length > k/2 # integer math
		end
		nil # no classification had majority
	end
end

def run_test
	training = read_train_csv({max_read: 20000, file_path: '../train.csv'})
	test = read_train_csv({max_read: 500, start_read: 20000, file_path: '../train.csv'})
	
	knnClassifier = KnnClassifier.new(training)

	correct = 0
	test.sort{|x,y| x.classification <=> y.classification}.each do |test_vector|
		known = test_vector.classification
		guess = knnClassifier.knn_classify(test_vector.vector, 3) || '?'
		puts "known: #{known} guess: #{guess} [#{known==guess ? '!' : ' '}]"
		correct += 1 if known == guess
	end

	puts "correct: #{correct} - #{correct * 100.to_f/test.length}%"

	nil
end