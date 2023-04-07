(define-public (take (amount int) (from principal))
    (let ((balance (- (default-to 0 (get amount (map-get? accounts {holder: from}))) amount)))
        (asserts! (is-eq tx-sender (var-get bank-owner)) err-unauthorized)
        (map-set accounts {holder: from} {amount: balance})
        (stx-transfer? (to-uint amount) (as-contract tx-sender) tx-sender)
    )
)

(define-public (save (amount uint))
    (begin 
        (try! (validate amount))
        (var-set saved amount)
        (ok amount)
    )
)

(define-private (validate (amount uint))
    (let ((current (var-get saved)))
        (asserts! (> amount current) err-too-low)
        (asserts! (<= amount (* current u2)) err-too-high)
        (ok amount)
    )
)


(define-public (dangerous (amount uint))
    (let ((sender tx-sender))
        ;; #[allow(unchecked_data)]
        (as-contract (stx-transfer? amount tx-sender sender))
    )
)

(define-public (filter_one (amount uint))
    (let ((sender tx-sender))
        ;; #[filter(amount)]
        (asserts! (> block-height u1000) (err u400))
        (as-contract (stx-transfer? amount tx-sender sender))
    )
)