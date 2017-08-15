# The service class handles score logic for user
class UserScoreService
  def initialize(params)
    @user = params[:user]
  end

  # update user score according to occurred action
  def update_score(action)
    @user.score ||= 0
    @user.score += UserScore.impact_value(action)
    @user.save
  end
end
