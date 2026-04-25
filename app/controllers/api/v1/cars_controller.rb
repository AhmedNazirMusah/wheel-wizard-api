class Api::V1::CarsController < ApplicationController
  def index
    @cars = Car.with_attached_image.all
    render json: @cars.map { |car|
      image_url = car_image_url(car)
      car.as_json.merge(image_url:)
    }, status: :ok
  end

  def new
    @car = Car.new
  end

  def show
    @car = Car.with_attached_image.find(params[:id])
    render json: @car.as_json.merge(image_url: car_image_url(@car)), status: :ok
  end

  def create
    @car = Car.new(car_params)
    @car.image.attach(params[:car][:image]) if params[:car][:image].present?

    if @car.save
      render json: @car, status: :created
    else
      render json: @car.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @car = Car.find(params[:id])
    if @car.destroy
      render json: { id: @car.id, message: 'Car was successfully deleted' }
    else
      render json: { error: 'Car could not be deleted' }, status: :bad_request
    end
  end

  private

  def car_params
    params.require(:car).permit(:name, :description, :price, :test_drive_fee, :model, :year)
  end

  def car_image_url(car)
    return fallback_image_url(car) unless car.image.attached?

    if car.image.blob.present? && car.image.blob.service.exist?(car.image.blob.key)
      url_for(car.image)
    else
      fallback_image_url(car)
    end
  rescue ActiveStorage::FileNotFoundError, Errno::ENOENT
    fallback_image_url(car)
  end

  def fallback_image_url(car)
    filename = car.image.attached? ? car.image.filename.to_s : default_image_filename(car.name)
    image_path = Rails.root.join('public', 'images', filename)

    return "#{request.base_url}/images/#{filename}" if File.exist?(image_path)

    default_filename = default_image_filename(car.name)
    default_path = Rails.root.join('public', 'images', default_filename)
    return "#{request.base_url}/images/#{default_filename}" if File.exist?(default_path)

    nil
  end

  def default_image_filename(name)
    normalized_name = name.to_s.downcase

    case normalized_name
    when /bugatti/
      'bugatti.png'
    when /dodge/
      'dodge.png'
    when /mercedes/
      'mercedes.png'
    when /mini/
      'mini-cooper.png'
    when /renault/
      'renault.png'
    else
      'car.webp'
    end
  end
end
