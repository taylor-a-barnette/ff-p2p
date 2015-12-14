class BlogsController < ApplicationController
	include CommentsHelper
	before_action :set_blog, only: [:show, :edit, :update, :destroy]
	before_action :set_user
	before_action except: [:show, :index] do
	  user_signed_in?
	  verify_creator_as_current_user(@blog)
	end
	before_action :current_user

	def index
		@blogs = @user.blogs.page(params[:page])
	end

	def show
		#@tags = @blog.tag_list
		@comments = @blog.comments.hash_tree(limit_depth: 3)
		@new_comment = Comment.new(parent_id: params[:parent_id])
	end

	def new
		@blog = Blog.new
	end

	def create
		@blog = Blog.new(blog_params)
		if params[:cogito].empty?
			@blog.user = current_user
			if @blog.save
				flash[:notice] = "You've posted a new blog entry!"
				redirect_to user_blog_path(@blog.user, @blog)
			else
				flash[:alert] = "Submission error. Make sure you've filled in all fields correctly."
				render 'new'
			end
		else
			flash[:alert] = "You didn't prove you're human! :("
			redirect_to new_appeal_path
			render 'new'
		end
	#end of create method
	end

	def edit

	end

	def update
		if params[:cogito].empty?
			if @blog.update(blog_params)
				flash[:notice] = "You've updated this post."
				redirect_to user_blog_path(@blog.user, @blog)
			else
				flash[:alert] = "Update error. Make sure you've filled in all fields correctly."
				render 'edit'
			end
		else
			flash[:alert] = "You didn't prove you're human! :("
			render 'edit'
		end
	end

	def destroy
		if @blog.destroy
			flash[:notice] = "You deleted this post."
			redirect_to user_path(current_user)
		else
			flash[:notice] = "Something went wrong - please try again."
			redirect_to user_blog_path(@blog.user, @blog)
		end
	end


	private

		def set_blog
			@blog = Blog.find_by(slug: params[:id])
			#use find_by to get slug, not find, which looks explicitly for id
		end

		def set_user
			@user = User.find_by(slug: params[:user_id])
		end

		def blog_params
			params.require(:blog).permit(
				:cogito,
				:title,
				:body
				#:tag_list
				)
		end

end