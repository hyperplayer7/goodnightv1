class Api::V1::SleepsController < ApplicationController
  protect_from_forgery with: :null_session

  def create
    # /api/v1/sleeps
    # user_id: integer, start_time: datetime, end_time: datetime
    user = User.where(id: sleep_params[:user_id]).first
    user = User.create(name: sleep_params[:name]) if user.blank?

    @sleep_record = SleepRecord.new
    @sleep_record.user_id = user.id
    @sleep_record.start_time = sleep_params[:start_time]
    @sleep_record.end_time = sleep_params[:end_time]

    if @sleep_record.save
      render json: user.sleep_records, status: :created
    else
      render json: @sleep_record.errors, status: :unprocessable_entity
    end
  end

  def follow
    # /api/v1/sleeps/:id/follow
    fan = User.where(id: sleep_params[:user_id]).first
    follow_user = User.where(id: params[:id]).first

    if fan && follow_user
      fan.send_follow_request_to(follow_user) unless fan.following?(follow_user)
      follow_user.accept_follow_request_of(fan)
      render json: { message: "You are now following user #{follow_user.id}" }
    else
      render json: { message: 'User does not exist' }, status: :unprocessable_entity
    end
  end

  def unfollow
    # /api/v1/sleeps/:id/unfollow
    fan = User.where(id: sleep_params[:user_id]).first
    unfollow_user = User.where(id: params[:id]).first

    if fan && unfollow_user
      fan.unfollow(unfollow_user)
      render json: { message: "You are no longer following user #{unfollow_user.id}" }
    else
      render json: { message: 'User does not exist' }, status: :unprocessable_entity
    end
  end

  def sleep_records
    # /api/v1/sleeps/:id/sleep_records
    user = User.where(id: params[:id]).first
    @friends = user ? user.following : []
    @sleep_records = []

    @friends.each do |friend|
      sleep_records = friend.sleep_records.within_last_week
      @sleep_records.concat(sleep_records)
    end
    @sleep_records.sort_by! { |message| -message.sleep_time }
    render json: @sleep_records
  end

  private

  def sleep_params
    params.permit(:user_id, :start_time, :end_time, :name)
  end
end
