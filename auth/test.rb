require 'json'

def test_handler(event:, context:)
    # TODO implement

  headers_list = {
    "Access-Control-Allow-Origin" => "*",
    "Access-Control-Allow-Headers" => "*",
    "Indybooks-git-commit-sha" => $my_git_commit_sha
  }

  { statusCode: 200, headers: headers_list, body: JSON.generate('Hello from Lambda!') }
end
