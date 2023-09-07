class DemoController < ApplicationController
  schema :create do
    required(:name).value(:string)
  end

  def create
    if safe_params.failure?
      render status: 400, json: safe_params.errors
    else
      demo = Demo.create!(safe_params.to_h)
      render status: 201, json: demo
    end
  end
end
