module Api
  # Controller that handles CRUD operations for scores
  class ScoresController < ApplicationController
    before_action :logged_in!
    before_action :validate_score_user_id, only: :destroy

    def user_feed
      scores = Score.all.order(played_at: :desc, id: :desc)
      serialized_scores = scores.map(&:serialize)

      response = {
        scores: serialized_scores,
      }

      render json: response.to_json
    end

    def index
      if params[:golfer_id].present?
        user = User.includes(:scores).find_by(id: params[:golfer_id])

        if user
          render json: {
            scores: user.scores.order(played_at: :desc).as_json(only: [:id, :total_score, :played_at])
          }
        else
          render json: { error: 'Golfer not found' }, status: :not_found
        end
      else
        scores = Score.order(played_at: :desc)
        render json: {
          scores: scores.as_json(only: [:id, :total_score, :played_at, :user_id])
        }
      end
    end

    def create
      score = current_user.scores.build(score_params)

      if score.save
        render json: {
          score: score.serialize
        }
      else
        render json: {
          errors: score.errors.messages
        }, status: :bad_request
      end
    end

    def destroy
      @score.destroy!

      render json: {
        score: @score.serialize
      }
    end

    private

    def score_params
      params.require(:score).permit(:total_score, :played_at)
    end

    def validate_score_user_id
      @score = Score.find(params[:id])

      return if @score.user_id == current_user.id

      render json: {
        errors: [
          'Score does not belong to user'
        ]
      }, status: :unauthorized
    end
  end
end
