(lang dune 3.20)

(name executor)

(generate_opam_files true)

(source
 (github username/reponame))

(authors "Author Name <author@example.com>")

(maintainers "Maintainer Name <maintainer@example.com>")

(license LICENSE)

(documentation https://url/to/documentation)

(using melange 0.1)

(pin
 (package
  (name server-reason-react))
 (url git+https://github.com/ml-in-barcelona/server-reason-react))

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
 (synopsis "A short synopsis")
 (description "A longer description")
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
  ("add topics" "to describe" your project)))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
