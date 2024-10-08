module MealDb 
  class Request
    BASE_URL = "www.themealdb.com/api/json/v1/1"

    def self.call(http_method, endpoint, params = {})

      headers = {'Content-Type' => 'application/json', 'Accept' => 'application/json'}.merge(params)

      result = RestClient::Request.execute(
        method: http_method,
        url: "#{BASE_URL}#{endpoint}",
        headers: headers
      )

      result_body = JSON.parse(result.body)

      # Checks if meals == nil only when searching by name, category, ingredient, or cuisine
      # meals key only exists for the mentioned searches aka GET requests
      if result_body.has_key?("meals") && result_body["meals"] == nil
        { code: result.code, status: 'Success', data: "Recipe not found."}
      else
        { code: result.code, status: 'Success', data: result_body}
      end

    rescue RestClient::ExceptionWithResponse => error 
      { code: error.http_code, status: error.message, data: Errors.map(error.http_code)}
    end
  end
end