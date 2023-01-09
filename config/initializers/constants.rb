# Defining all constants used in project

# Regex for email validation
EMAIL_REGEX = /\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})/

# Mobile number start with country code followed by number 
MOBILE_NO_REGEX = /(\+?\d{1,4}[\s-])?(?!0+\s+,?$)\d{10}\s*,?/

# Regex for password validation (At least one capital, one small and one special charater  )
PASSWORD_REGEX = /(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]/
