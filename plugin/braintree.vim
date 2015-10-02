if exists("g:loaded_bt") || &cp
  finish
endif
let g:loaded_bt = 1

command BraintreeShowConfig :call BraintreeShowConfig()
command -nargs=1 BraintreeFindTransaction :call BraintreeFindTransaction(<f-args>)

fu! ColorEcho(str)
  let index=0
  for item in split(a:str,"|")
    let index+=1
    if index % 2
      echon item
    el
      exec "echohl " . item
    en
  endfo
endf

function! IsBraintreeConfigured()
  if !exists("g:BraintreeMerchantID")
    call ColorEcho("Braintree Error: |Error|g:BraintreeMerchantID must be set")
    return 0
  end
  if !exists("g:BraintreePublicKey")
    call ColorEcho("Braintree Error: |Error|g:BraintreePublicKey must be set")
    return 0
  end
  if !exists("g:BraintreePublicKey")
    call ColorEcho("Braintree Error: |Error|g:BraintreePrivateKey must be set")
    return 0
  end

  return 1
endfunction

function! BraintreeConfig(merchantId, publicKey, privateKey)
  " let g:BraintreeMerchantID = a:merchantId
  let g:BraintreePublicKey = a:publicKey
  let g:BraintreePrivateKey = a:privateKey
endfunction

function! BraintreeShowConfig()
  if !IsBraintreeConfigured()
    return
  end

  let maskedPrivateKey = strpart(g:BraintreePrivateKey, 0, 5) . "********"
  call ColorEcho(" |Error|BT Config|None| - Merchant ID: |String|".g:BraintreeMerchantID." |None|Public Key: |String|".g:BraintreePublicKey." |None|Private Key: |String|".maskedPrivateKey."|None|")
endfunction


function! BraintreeFindTransaction(transactionId)
  if !IsBraintreeConfigured()
    return
  end

  let output = system('curl -s https://sandbox.braintreegateway.com/merchants/'.g:BraintreeMerchantID.'/transactions/'.a:transactionId.' -u "'.g:BraintreePublicKey.':'.g:BraintreePrivateKey.'" -H "X-ApiVersion: 4" -H "Content-Type: application/xml" -H "User-Agent: API Demo 0.1.0"')
  echo output
endfunction
