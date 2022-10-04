class RecipesController < ApplicationController
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record
  
  def index
      recipes = Recipe.all
      if session[:user_id]
          render json: recipes, include: :user
      else
          render json: {errors: ["Not Authorized", "Not logged in"]}, status: :unauthorized
      end
  end

  def create
      if session.include?(:user_id)
          recipe = Recipe.new(recipe_params)
          recipe.user_id = session[:user_id]
          recipe.save!
          render json: recipe, include: :user, status: :created
      else
          render json: {errors: ["Not Authorized", "Not logged in"]}, status: :unauthorized
      end
  end

  private

  def recipe_params
      params.permit(:title, :instructions, :minutes_to_complete)
  end

  def invalid_record(invalid)
      render json: { errors: invalid.record.errors.full_messages }, status: :unprocessable_entity
  end

end