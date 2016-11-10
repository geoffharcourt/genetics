require "csv"
require "genetics"
require "pry-byebug"

csv_rows = CSV.read("/Users/geoff/Desktop/z_scores.csv", headers: true)

def positions_from_row(row)
  positions = row["positions"].split(", ").map(&:to_sym)

  if positions.include?(:c)
    positions = [:c]
  end

  positions
end
genes  = csv_rows.map do |row|
  PlayerGene.new(
    name: row["player_id"],
    pa: row["pa"].to_i,
    value_range: positions_from_row(row),
    z_score: row["total_z"].to_f,
  )
end

GENES = genes
LIMITS = {
  c: 7200,
  "1b".to_sym => 7700,
  "2b".to_sym => 7700,
  ss: 7700,
  "3b".to_sym => 7700,
  of: 7700,
  cf: 7700,
  rf: 7700,
  u: 15400,
}

Genetics.genes = GENES
Genetics.limits = LIMITS
