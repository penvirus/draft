#ifndef __RESPONSE_H__
#define __RESPONSE_H__

/* 1XX - Continue */
#define RESPONSE_CODE_CONTINUE 150
#define RESPONSE_MESSAGE_CONTINUE "Continue"

#define RESPONSE_CODE_SENDING 151
#define RESPONSE_MESSAGE_SENDING "Sending"


/* 2XX - Positive */
#define RESPONSE_CODE_OK 250
#define RESPONSE_MESSAGE_OK "OK"

#define RESPONSE_CODE_WARNING 251
#define RESPONSE_MESSAGE_WARNING "Warning"


/* 4XX - Negative */
#define RESPONSE_CODE_REQUEST_REJECTED 450
#define RESPONSE_MESSAGE_REQUEST_REJECTED "Request Rejected"

#define RESPONSE_CODE_BAD_REQUEST 451
#define RESPONSE_MESSAGE_BAD_REQUEST "Bad Request"

#define RESPONSE_CODE_INSUFFICIENT_METADATA 452
#define RESPONSE_MESSAGE_INSUFFICIENT_METADATA "Insufficient Meta-data"


/* 5XX - Internal Error */
#define RESPONSE_CODE_INTERNAL_ERROR 550
#define RESPONSE_MESSAGE_INTERNAL_ERROR "Internal Error"

const char * response_code2message(int code);

#endif

