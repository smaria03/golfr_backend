# Model to represent a score played by a golfer
# - total_score: total number of hits to finish all 18 holes
# - played_at: date when the score was played
class Score < ApplicationRecord
  belongs_to :user

  validates :number_of_holes, inclusion: {in: [9, 18]}
  validate :future_score
  validate :score_values

  def serialize
    {
      id: id,
      user_id: user_id,
      user_name: user.name,
      total_score: total_score,
      number_of_holes: number_of_holes,
      played_at: played_at,
    }
  end

  private

  def future_score
    errors.add(:played_at, 'must not be in the future') if played_at > Time.zone.today
  end

  def score_values
    return if total_score.blank? || number_of_holes.blank?

    if number_of_holes == 9 && !total_score.between?(27, 89)
      errors.add(:total_score, 'must be between 27 and 89 for a 9-hole course')
    elsif number_of_holes == 18 && !total_score.between?(54, 179)
      errors.add(:total_score, 'must be between 54 and 179 for an 18-hole course')
    end
  end
end
