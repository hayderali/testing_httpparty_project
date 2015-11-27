require 'spec_helper'
require 'httparty'


describe "Test Suite sends a post request" do
 
 
  it "be able to create a new post into the  collection" do
    #execute
    post_message = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Hayder is testing", due: "2900-01-02"}
	
    #verify
    expect(post_message["title"]).to eq ("Hayder is testing")
    expect(post_message.code).to eq(201)
		expect(post_message.message).to eq("Created")
    #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post_message["id"]}"
    #puts "successfully teardown posting a message"
  end
  
   it "fail to make a post when only entering title parametre" do
		#execute
		only_title = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Do something interesting"}
		#verify
		expect(only_title.code).to eq(422)
		expect(only_title.message).to eq("Unprocessable Entity")
		
  end


  it "fail to make a post when only entering date parametre" do
		#execute 
		only_title = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Do something interesting"}
		#verify
		expect(only_title.code).to eq(422)
		expect(only_title.message).to eq("Unprocessable Entity")
		
  end
 
  it "fail to make a post when no parametres are sent" do
    #execute
		only_title = HTTParty.post "http://lacedeamon.spartaglobal.com/todos"
		#verify
    expect(only_title.code).to eq(422)
		expect(only_title.message).to eq("Unprocessable Entity")
  end
end 
  
describe "Test Suite sends a get request" do
  it "read get the hash at a specific ID" do
  
    #execute
    post_message = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Hayder is testing", due: "2900-01-02"}
    get_id = HTTParty.get "http://lacedeamon.spartaglobal.com/todos/#{post_message["id"]}"
    
    #verify
    expect(post_message["title"]).to eq ("Hayder is testing")
    expect(post_message.code).to eq(201)
		expect(post_message.message).to eq("Created")
    
    expect(get_id.code).to eq(200)
    expect(get_id.message).to eq("OK")
    expect(get_id.content_type).to eq("application/json")
        
    #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post_message["id"]}"
    
    
  end
  
  it "return all IDs if collection is requested" do    
    message_1 = HTTParty.post 'http://lacedeamon.spartaglobal.com/todos', query: {title: "testing 1", due: 66/66/6666}
    message_2 = HTTParty.post 'http://lacedeamon.spartaglobal.com/todos', query: {title: "testing 2", due: 66/66/6666}
    checking_collection = HTTParty.get 'http://lacedeamon.spartaglobal.com/todos/'
    expect(checking_collection.code).to eq(200)
    expect(checking_collection.content_type).to eq("application/json")
    #expect(checking_collection).to be("message_1['id'], message_2['id']")
  end 
    
end

describe "Test Suite sends a put request" do
    #execute
    it "update a single todo from an ID" do
    post_message= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Apple", due: "2014-10-01"}
    put_message= HTTParty.put "http://lacedeamon.spartaglobal.com/todos/#{post_message['id']}", query:{title: "Banana", due: "2014-10-01"}
    #verify
    expect(post_message["title"]).to eq("Apple")
    expect(put_message["title"]).to eq("Banana")
    expect(put_message.message).to eq("OK")
    expect(put_message.code).to eq(200)
  #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{put_message['id']}" 
   
    end
end

describe "Test Suite sends a patch request" do
  it "update only the title from an ID" do
    #execute
    post_message= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Apple", due: "2014-10-01"}
    patch_message= HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/#{post_message['id']}", query:{title: "Banana"}
    #verify
    expect(post_message["title"]).to eq("Apple")
    expect(patch_message["title"]).to eq("Banana")
    expect(patch_message.message).to eq("OK")
    expect(patch_message.code).to eq(200)
    #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{patch_message['id']}" 
  end
  
  it "fail to update when both are entered" do
    #execute
    post_message= HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Apple", due: "2014-10-01"}
    patch_message= HTTParty.patch "http://lacedeamon.spartaglobal.com/todos/#{post_message['id']}", query:{title: "Banana", due: "2014-10-02"}
    #verify
    expect(post_message["due"]).to eq("2014-10-01")
    ##fail to update from "2014-10-01" -> "2014-10-02"
    expect(patch_message["due"]).to eq("2014-10-01")
    expect(post_message["title"]).to eq("Apple")
    expect(patch_message["title"]).to eq("Banana")
    expect(patch_message.message).to eq("OK")
    expect(patch_message.code).to eq(200)
    #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{patch_message['id']}" 
  end
end

describe "Test suite sends a delete request" do
  it "delete a single todo" do
    #execute
    post_message = HTTParty.post "http://lacedeamon.spartaglobal.com/todos", query:{title: "Hayder is testing", due: "2900-01-02"}
    delete_message = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post_message['id']}"
    #verify
    expect(delete_message.code).to eq(204)
		expect(delete_message.message).to eq("No Content")
    #teardown
    HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/#{post_message["id"]}"
    #puts "successfully teardown posting a message"
  
  end
  
  it "fail to delete entire collection" do
    #execute
    delete_message = HTTParty.delete "http://lacedeamon.spartaglobal.com/todos/"
    #verify
    expect(delete_message.code).to eq(405)   
    expect(delete_message.message).to eq ("Method Not Allowed")
  end
  
end