require "spec_helper"

describe Genetics do
  describe "#fitness" do
    xit "returns the sum of the z-scores for each position, taking the best players before meeting the positions' threshold" do
      best_2b = PlayerGene.new(
        name: "Altuve",
        pa: 100,
        value_range: %i(2b),
        z_score: 1000,
      )
      next_2b = PlayerGene.new(
        name: "Cano",
        pa: 150,
        value_range: %i(2b),
        z_score: 100,
      )
      cut_2b = PlayerGene.new(
        name: "Dozier",
        pa: 150,
        value_range: %i(2b),
        z_score: 10,
      )
      a_utility = PlayerGene.new(
        name: "Ortiz",
        pa: 150,
        value_range: %i(u),
        z_score: 50,
      )
      described_class.genes = [best_2b, cut_2b, next_2b, a_utility]
      described_class.limits = { "2b".to_sym => 249, u: 1000 }

      organism = described_class.new

      expect(organism.fitness).to eq(1150)
    end
  end

  describe "evolution" do
    it "evolves without exception" do
      best_2b = PlayerGene.new(
        name: "Altuve",
        pa: 100,
        value_range: %i(2b u),
        z_score: 1000,
      )
      next_2b = PlayerGene.new(
        name: "Cano",
        pa: 150,
        value_range: %i(2b u),
        z_score: 100,
      )
      cut_2b = PlayerGene.new(
        name: "Dozier",
        pa: 150,
        value_range: %i(2b u),
        z_score: 10,
      )
      a_utility = PlayerGene.new(
        name: "Ortiz",
        pa: 150,
        value_range: %i(u),
        z_score: 50,
      )
      described_class.genes = [best_2b, cut_2b, next_2b, a_utility]
      described_class.limits = { "2b".to_sym => 175, u: 40 }

      population = Darwinning::Population.new(
        organism: described_class,
        fitness_goal: 1200,
        generations_limit: 3,
        population_size: 4,
      )

      population.make_next_generation!
    end
  end
end
