local thing = {}

function thing:getResponse(args)
    local response = syn.request({
        Url = string.format("https://raw.githubusercontent.com/%s/%s/main/%s", args.Owner, args.Repository, args.File),
        Method = "GET",
        Headers = {
            ["Authorization"] = args.Token and "token " .. tostring(args.Token) or "",
            ["Content-Type"] = "application/json"
        }
    })

    if response.Success then
        return(response)
    else
        return warn(response.StatusCode .. ": " .. response.StatusMessage)
    end
end

return thing
