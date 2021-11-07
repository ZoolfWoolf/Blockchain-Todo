;;Default list to get for the first time. Cant return an empty array so we need dis.
(define-data-var default-junk (list 50 (string-ascii 50)) (list ""))

;;Global variable to store what todo to delete.
(define-data-var to-delete (string-ascii 50) "")

;;The map im going to use, it has a list of todos.
(define-map user-todo {userName: (string-ascii 10)} {todo: (list 50 (string-ascii 50))})

;;This is my filter used to compare and remove the todos from lists.
(define-private (myFilter (temp (string-ascii 50)))
  (not (is-eq (var-get to-delete) temp))
)

(define-public (delete-todo (name (string-ascii 10)) (task (string-ascii 50)))
  (let ;; Getting the todos of the user
    (
      (tasks (default-to (var-get default-junk) ( get todo (map-get? user-todo { userName: name }))))
    )

    ;;Setting the todo to remove.
    (var-set to-delete task)

    (map-set user-todo { userName: name } {todo: (unwrap-panic (as-max-len? (filter myFilter tasks) u50))})
    (ok true)
  )
)

(define-public (add-todo (name (string-ascii 10)) (task (string-ascii 50)))
  (let ;;Local variables can only be made inside let in a seperate ().
    (
      (tasks (default-to (var-get default-junk) ( get todo (map-get? user-todo { userName: name }))))
    )
    (if (< (len tasks) u2)
    (ok (map-set user-todo {userName: name} {todo: (unwrap-panic (as-max-len? (append tasks task) u50)) }))
    (err "No more space")
    )
  )
)

;;Just a basic print function.
(define-public (get-todo (name (string-ascii 10)))
  (ok (map-get? user-todo {userName: name}))
)
