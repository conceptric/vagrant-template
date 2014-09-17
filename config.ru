app = proc do |env|
    [200, { "Content-Type" => "text/html" }, ["<b>Hello World</b>: testing passenger"]]
end
run app