(lang dune 3.20)

(name executor)

(generate_opam_files true)

(source
 (github Software-Deployed/executor))

(authors "Brian Kaplan <brian@equalslashed.net>")

(license MIT)

(using melange 0.1)

(package
 (name executor)
 (synopsis "Realtime e-commerce platform")
 (description "E-commerce with real time transactions and synchronization")
 (depends
  ocaml
  melange
  ocaml-lsp-server
  ocamlformat
  reason
  melange-webapi
  ppxlib
  reason-react-ppx
  reason-react)
 (allow_empty)
 (tags
  ("web" "commerce" "lease" "subscription" "cart")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
