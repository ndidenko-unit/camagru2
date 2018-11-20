class ProductsController < ApplicationController

  before_action :set_product, only: [:show, :edit, :update, :destroy,
                                     :add_comment, :delete_comment, :like_post]
  before_filter :authenticate_user! # Devise

  # GET /products
  def index
    @products = Product.all.order_and_paginate(:page => params[:page], :per_page => 5)
    @products = current_user.products.
        order_and_paginate(:page => params[:page], :per_page => 5) if params[:only_my] == "1"
    # binding.pry
  end

  # GET /products/1
  def show
    @comments = Comment.where(product_id: @product.id)
    @link_name = @product.liked?(current_user) ? 'Unlike' : 'Like'
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
    # binding.pry
    if @product.update(product_params)
      redirect_to @product, notice: 'Product was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /products/1
  def destroy
    @product.destroy if current_user.id == @product.user.id
    redirect_to products_url, notice: 'Product was successfully destroyed.'
  end

  def add_comment
    @product.update_attribute('updated_at', Time.now)
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

  def like_post
    # binding.pry
    @product.update_attribute('updated_at', Time.now)
    if @product.liked? current_user
      @product.unliked_by current_user
      redirect_to request.referer, notice: 'Post was successfully unliked.'
    else
      @product.liked_by current_user
      redirect_to request.referer, notice: 'Post was successfully liked.'
    end
  end

  private
    def set_product
      @product = Product.find(params[:id])
    end

    def product_params
      params[:product][:image] = params[:product][:file] if params[:product][:file].present?
      params[:product][:image] = File.open(add_frame(params)) if params[:frame_name].present? && params[:id].present?
      params.require(:product).permit(:name, :image).merge(user_id: current_user.id)
    end

    def add_frame(params)
      img_orig = "#{Rails.root}/public/uploads/product/image/#{params[:id]}/image.jpeg"
      img_copy = "#{Rails.root}/public/uploads/product/image/#{params[:id]}/imagecopy.jpeg"
      if File.exist?(img_orig)
        FileUtils.cp(img_orig, img_copy)
      else
        FileUtils.cp(img_copy, img_orig)
      end
      first_image = MiniMagick::Image.open "#{Rails.root}/public/uploads/product/image/#{params[:id]}/image.jpeg"
      second_image = MiniMagick::Image.open "#{Rails.root}/public/frames/#{params[:frame_name]}.png"
      result = first_image.composite(second_image) do |c|
        c.compose "Over"
        c.geometry "+20+20"
      end
      result.write "#{Rails.root}/public/uploads/product/image/#{params[:id]}/#{params[:frame_name]}.jpeg"
      "#{Rails.root}/public/uploads/product/image/#{params[:id]}/#{params[:frame_name]}.jpeg"
    end
end
