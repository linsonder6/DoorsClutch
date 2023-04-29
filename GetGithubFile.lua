local thing = {}
local Request = (syn and syn.request) or request or http_request or HttpPost

function thing:getResponse(args)
    local response = Request({
        Url = string.format("https://raw.githubusercontent.com/%s/%s/main/%s", args.Owner, args.Repository:gsub(" ","%%20"), args.File:gsub(" ","%%20")),
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
