# TODO 4 spaces instead of tabs
def euclidean_distance(a, b)
	raise Exception.new('euclidean_distance expects vectors of same length') if a.length != b.length
	Math.sqrt(a.zip(b).inject(0){ |sum, o| sum + ((o[0] - o[1])**2) })
end

class TrainingVector
	attr_accessor :classification, :vector
	def initialize(classification, vector)
		@classification = classification
		@vector = vector
	end
	def to_s
		"TV<c:#{classification}>"
	end
	def draw
		@vector.each_slice(28).each { |pxs| 
			puts pxs.map{ |px| 
				px == 0 ? ' ' : 
					px <= 128 ? '.' : 
						px <= 192 ? '+' :
							px <= 252 ? '*' : '%'
			}.join()
		}
	end
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

	def multi_classify(vector, k = 5)
		knn = knn(vector, k)
		{
			majority: majority_classification_on_knn(knn, k),
			weighted: weighted_classification_on_knn(knn, k)
		}
	end

	def majority_classify(vector, k = 5)
		majority_classification_on_knn(knn(vector, k), k)
	end

	def weighted_classify(vector, k = 5)
		weighted_classification_on_knn(knn(vector, k), k)
	end

	protected

	def majority_classification_on_knn(knn, k)
		knn.values.each do |tv| # TODO make this not dumb. im tired.
			return tv.classification if knn.values.select{|tv2|tv.classification == tv2.classification}.length > k/2 # integer math
		end
		nil # no classification had majority
	end

	def weighted_classification_on_knn(knn, k)
		weights = {}
		knn.each do |e_d, training_vector|
			weights[training_vector.classification] ||= 0
			weights[training_vector.classification] += 1 / e_d # exact matches will produce a divide by 0
		end
		weights.key(weights.values.max) # classification with max weight, no guarantee of order in case of tie
	end
end

def read_training_vectors(opts = {})
	require 'csv'

	training_vectors = []
	start_read = opts[:start] || 0
	max_read = opts[:max]
	file_path = opts[:file] || 'train.csv'

	skip_i = -1  # first row of csv is labels we dont care about.
	read_i = 0
	CSV.foreach(file_path) do |row|
		(skip_i += 1) and next if skip_i < start_read # could optimize this out
		training_vectors << TrainingVector.new(row.shift, row.map(&:to_i))
		break if !max_read.nil? && (read_i += 1) == max_read
	end

	training_vectors
end
alias :rtv :read_training_vectors

def run_test
	require 'pp'
	training = read_training_vectors(max: 10000, file: '../train.csv')
	test = read_training_vectors(max: 1000, start: 10000, file: '../train.csv')
	
	knnClassifier = KnnClassifier.new(training)

	correct = {
		majority: 0,
		weighted: 0
	}
	digits_correct = {
		majority: -> {h = {} and ("0".."9").each do |d| h[d] = 0 end; h}.call,
		weighted: -> {h = {} and ("0".."9").each do |d| h[d] = 0 end; h}.call
	}
	digits_incorrect = {
		majority: -> {h = {} and ("0".."9").each do |d| h[d] = 0 end; h}.call,
		weighted: -> {h = {} and ("0".."9").each do |d| h[d] = 0 end; h}.call
	}
	test.sort{|x,y| x.classification <=> y.classification}.each do |test_vector|
		known = test_vector.classification

		multi_classify = knnClassifier.multi_classify(test_vector.vector, 3)
		majority_guess = multi_classify[:majority] || '?'
		weighted_guess = multi_classify[:weighted]

		puts "known: #{known} majority_guess: #{majority_guess} [#{known==majority_guess ? '!' : ' '}] weighted_guess: #{weighted_guess} [#{known==weighted_guess ? '!' : ' '}]"
		
		if known == majority_guess
			correct[:majority] += 1 
			digits_correct[:majority][known] += 1
		else
			digits_incorrect[:majority][known] += 1
		end

		if known == weighted_guess
			correct[:weighted] += 1 
			digits_correct[:weighted][known] += 1
		else
			digits_incorrect[:weighted][known] += 1
		end
	end

	puts " - - MAJORITY - -"
	puts "correct: #{correct[:majority]} - #{correct[:majority] * 100.to_f/test.length}%"
	puts "digits correct:"
	pp digits_correct[:majority]
	puts "digits incorrect:"
	pp digits_incorrect[:majority]

	puts " - - WEIGHTED - -"
	puts "correct: #{correct[:weighted]} - #{correct[:weighted] * 100.to_f/test.length}%"
	puts "digits correct:"
	pp digits_correct[:weighted]
	puts "digits incorrect:"
	pp digits_incorrect[:weighted]
	nil
end