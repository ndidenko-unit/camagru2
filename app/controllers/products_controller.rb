class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy, :add_comment, :delete_comment]
  before_filter :authenticate_user! # для Devise

  # GET /products
  def index
    @products = Product.all
  end

  # GET /products/1
  def show
    @comments = Comment.where(product_id: @product.id)
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  def create
    @product = Product.new(product_params)

    if @product.save
      redirect_to @product, notice: 'Product was successfully created.'
    else
      render :new
    end
  end

  # PATCH/PUT /products/1
  def update
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def add_comment
    if Comment.create(comment_text: params[:comment], user_id: current_user.id, product_id: params[:id])
      redirect_to @product, notice: 'Comment was successfully added.'
    else
      redirect_to @product, notice: 'No comment has been added.'
    end
  end

  def delete_comment
    # binding.pry
    comment = Comment.find_by_id(params[:comment_id])
    if current_user.id == comment.user.id
      comment.destroy
      redirect_to @product, notice: 'Comment was successfully deleted.'
    else
      redirect_to @product, notice: 'The comment has not been deleted.'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def product_params
      params[:product][:image] = params[:product][:file] if params[:product][:file].present?
      params.require(:product).permit(:name, :image).merge(user_id: current_user.id)
    end
end
