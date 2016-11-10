require "darwinning"
require "genetics/version"

class PlayerGene < Darwinning::Gene
  attr_reader :pa, :z_score

  def initialize(options)
    @pa = options.fetch(:pa, 0)
    @z_score = options.fetch(:z_score, 0)
    super
  end
end

class Genetics < Darwinning::Organism
  UNFIT_FITNESS_SCORE = -1500

  class << self
    attr_accessor :limits
  end

  def fitness
    z_score_sums = self.class.limits.keys.inject(0) do |memo, position|
      memo += z_score_average_for_position(position)

      memo
    end

    puts "Z-score sums: #{z_score_sums}"

    @fitness = (z_score_sums - 500).abs
  end

  def position_values
    self.class.limits.keys.each_with_object({}) do |position, memo|
      memo[position] = z_score_average_for_position(position)
    end
  end

  private

  def z_score_average_for_position(position)
    collected_pa = 0

    position_genotypes = sorted_genotypes_for_position(position)
    pa_sum_for_position_genotypes =
      position_genotypes.map(&:pa).reduce(:+) || 0

    if pa_sum_for_position_genotypes > self.class.limits[position]
      position_genotypes.take_while do |genotype|
        collected_pa < self.class.limits.fetch(position) &&
          collected_pa += genotype.pa
      end.map(&:z_score).reduce(:+) / [1, position_genotypes.count].max
    else
      UNFIT_FITNESS_SCORE
    end
  end

  def sorted_genotypes_for_position(position)
    genotypes_for_position(position).sort_by(&:z_score).reverse
  end

  def genotypes_for_position(query_position)
    genotypes.select do |genotype, position|
      position == query_position && genotype.class == PlayerGene
    end.keys
  end
end
