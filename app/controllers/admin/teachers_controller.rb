module Admin

  class TeachersController < BaseController
    before_action :set_teacher, only: %i[show update destroy seminars]

    def index
      authorize Teacher
      @teachers = Teacher.order(:last_name).all
      respond_to do |format|
        format.html
        format.xlsx
      end
    end

    def new
      authorize Teacher
      @teacher = Teacher.new
    end

    def show
    end

    def create
      authorize Teacher
      @teacher = Teacher.new teacher_params

      if @teacher.save
        redirect_to admin_teachers_url, notice: t(:created, model: Teacher.model_name.human)
      else
        render :new
      end
    end

    def update
      if @teacher.update teacher_params
        redirect_to admin_teachers_url, notice: t(:updated, model: Teacher.model_name.human)
      else
        render :show
      end
    end

    def destroy
      @teacher.destroy
      redirect_to admin_teachers_url, notice: t(:destroyed, model: Teacher.model_name.human)
    end

    def seminars
      @seminars = @teacher.seminars.order(:date)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_teacher
      @teacher = Teacher.find params[:id]
      authorize @teacher
    end

    # Only allow a trusted parameter "white list" through.
    def teacher_params
      params.require(:teacher).permit(
        :first_name, :last_name, :profession, :title, :skill_sets, :remarks,
        address: %i[street zip city], contact: %i[email phone mobile fax]
      )
    end
  end
end
