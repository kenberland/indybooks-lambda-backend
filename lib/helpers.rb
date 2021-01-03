OK = 200
BAD_REQUEST = 400
NOT_FOUND = 404
SERVER_ERROR = 500
INDY_ENV = ENV['INDY_ENV']
FORBIDDEN = 403
UUID_REGEX = /[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}/

def get_cognito_username ctx
  ctx['requestContext']['authorizer']['claims']["cognito:username"]
end
