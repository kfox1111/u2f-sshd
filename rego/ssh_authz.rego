package sshd.authz

import input.display_responses
import input.pull_responses
import input.sysinfo

default allow = false

allow {
    sysinfo.pam_username == "kfox"
    display_responses.inputok == "ok"
}

errors["You cannot pass!"] {
    not allow
}
