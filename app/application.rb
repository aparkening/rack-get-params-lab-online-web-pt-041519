class Application

  @@items = ["Apples","Carrots","Pears"]
  @@cart = []

  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
 
    case
      when req.path.match(/items/)
        @@items.each do |item|
          resp.write "#{item}\n"
        end
      when req.path.match(/search/)
        search_term = req.params["q"]
        resp.write handle_search(search_term)
      when req.path.match(/cart/)
        if @@cart.empty?
          resp.write "Your cart is empty"
        else
          @@cart.each { |item| resp.write "#{item}\n"}
        end
      when req.path.match(/add/)
        item_term = req.params["item"]
        if @@items.include?(item_term)
          @@cart << item_term
          resp.write "added #{item_term}"
        else 
          resp.write "We don't have that item"
        end
      else
        resp.write "Path Not Found"
    end

    resp.finish
  end

  def handle_search(search_term)
    if @@items.include?(search_term)
      return "#{search_term} is one of our items"
    else
      return "Couldn't find #{search_term}"
    end
  end
end
