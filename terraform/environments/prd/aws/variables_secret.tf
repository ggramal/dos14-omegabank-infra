variable "secrets" {
  type = object({
    authn = string
    authz = string
    bank  = string
  })
  default = {
    authn = "ggramal"
    authz = ""
    bank  = "bank"
}
}
