(lang dune 3.20)

(name executor)

(generate_opam_files true)

(source
 (github Software-Deployed/executor))

(authors "Brian Kaplan <brian@equalslashed.net>")

(license MIT)

(using melange 0.1)

(pin
 (package
  (name reason-react)
  (version 0.17.0))
 (url git+https://github.com/reasonml/reason-react))

(pin
 (package
  (name reason-react-ppx)
  (version 0.17.0))
 (url git+https://github.com/reasonml/reason-react))

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
  (reason-react-ppx
   (>= 0.17.0))
  (reason-react
   (>= 0.17.0)))
 (allow_empty)
 (tags
  ("web" "commerce" "lease" "subscription" "cart")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
