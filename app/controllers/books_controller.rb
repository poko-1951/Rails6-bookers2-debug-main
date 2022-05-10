class BooksController < ApplicationController
  impressionist :actions => [:show, :index]

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @book_comment = BookComment.new
    @currentUserEntry = Entry.where(user_id: current_user.id)
    @userEntry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @currentUserEntry.each do |cue|
        @userEntry.each do |ue|
          if cue.room_id == ue.room_id
            @existenceRoom = true
            @roomId = cue.room_id
          end
        end
      end
      unless @existenceRoom
        @room = Room.new
        @entry = Entry.new
      end
    end
    impressionist(@book, nil, unique: [:session_hash])
  end

  def index
    @book = Book.new
    to = Time.current.at_end_of_day
    from = (to-6.day).at_beginning_of_day
    @books = Book.includes(:favorites).sort { |a, b| b.favorites.where(created_at: from...to).size <=> a.favorites.where(created_at: from...to).size }
  end

  def create
    @book = Book.new(book_params)
    @book.user = current_user
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render :index
    end
  end

  def edit
    @book = Book.find(params[:id])
    if @book.user == current_user
      render :edit
    else
      redirect_to books_path
    end
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end
end
