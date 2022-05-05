class SearchesController < ApplicationController
  def search
    @content = params["content"]
    @model = params["model"]
    @method = params["method"]
    if @model == "user"
      if @method == "perfect"
        @users = User.where("name LIKE ?", "#{@content}")
      elsif @method == "forward"
        @users = User.where("name LIKE ?", "#{@content}%")
      elsif @method == "backward"
        @users = User.where("name LIKE ?", "%#{@content}")
      else
        @users = User.where("name LIKE ?", "%#{@content}%")
      end
    elsif @model == "book"
      if @method == "perfect"
        @books = Book.where("title LIKE ?", "#{@content}")
      elsif @method == "forward"
        @books = Book.where("title LIKE ?", "#{@content}%")
      elsif @method == "backward"
        @books = Book.where("title LIKE ?", "%#{@content}")
      else
        @books = Book.where("title LIKE ?", "%#{@content}%")
      end
    end
  end
end
