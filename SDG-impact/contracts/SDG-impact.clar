;; SDG Impact Tracker Smart Contract
;; A decentralized system for tracking and verifying Sustainable Development Goals projects

;; Constants
(define-constant contract-owner tx-sender)
(define-constant err-owner-only (err u100))
(define-constant err-project-not-found (err u101))
(define-constant err-invalid-impact-score (err u102))
(define-constant err-project-already-exists (err u103))
(define-constant err-unauthorized-verifier (err u104))

;; Data Variables
(define-data-var project-counter uint u0)

;; Data Maps
(define-map projects
  { project-id: uint }
  {
    title: (string-ascii 100),
    description: (string-ascii 500),
    sdg-goal: uint,
    creator: principal,
    impact-score: uint,
    verified: bool,
    funding-target: uint,
    funding-raised: uint,
    created-at: uint
  }
)

(define-map project-updates
  { project-id: uint, update-id: uint }
  {
    description: (string-ascii 300),
    impact-evidence: (string-ascii 200),
    timestamp: uint,
    reporter: principal
  }
)

(define-map authorized-verifiers
  { verifier: principal }
  { authorized: bool }
)

(define-map user-contributions
  { user: principal, project-id: uint }
  { amount: uint }
)

;; Read-only functions
(define-read-only (get-project (project-id uint))
  (map-get? projects { project-id: project-id })
)

(define-read-only (get-project-update (project-id uint) (update-id uint))
  (map-get? project-updates { project-id: project-id, update-id: update-id })
)

(define-read-only (get-user-contribution (user principal) (project-id uint))
  (default-to u0 
    (get amount (map-get? user-contributions { user: user, project-id: project-id }))
  )
)

(define-read-only (is-authorized-verifier (verifier principal))
  (default-to false 
    (get authorized (map-get? authorized-verifiers { verifier: verifier }))
  )
)

(define-read-only (get-total-projects)
  (var-get project-counter)
)

;; Public functions
(define-public (create-project 
  (title (string-ascii 100))
  (description (string-ascii 500))
  (sdg-goal uint)
  (funding-target uint)
)
  (let
    (
      (new-project-id (+ (var-get project-counter) u1))
    )
    (asserts! (and (>= sdg-goal u1) (<= sdg-goal u17)) err-invalid-impact-score)
    (asserts! (> funding-target u0) err-invalid-impact-score)
    
    (map-set projects
      { project-id: new-project-id }
      {
        title: title,
        description: description,
        sdg-goal: sdg-goal,
        creator: tx-sender,
        impact-score: u0,
        verified: false,
        funding-target: funding-target,
        funding-raised: u0,
        created-at: block-height
      }
    )
    
    (var-set project-counter new-project-id)
    (ok new-project-id)
  )
)

(define-public (contribute-to-project (project-id uint) (amount uint))
  (let
    (
      (project (unwrap! (get-project project-id) err-project-not-found))
      (current-contribution (get-user-contribution tx-sender project-id))
      (current-raised (get funding-raised project))
    )
    (asserts! (> amount u0) err-invalid-impact-score)
    
    ;; Update user contribution
    (map-set user-contributions
      { user: tx-sender, project-id: project-id }
      { amount: (+ current-contribution amount) }
    )
    
    ;; Update project funding
    (map-set projects
      { project-id: project-id }
      (merge project { funding-raised: (+ current-raised amount) })
    )
    
    (ok true)
  )
)

(define-public (add-project-update 
  (project-id uint)
  (update-id uint)
  (description (string-ascii 300))
  (impact-evidence (string-ascii 200))
)
  (let
    (
      (project (unwrap! (get-project project-id) err-project-not-found))
    )
    (asserts! (is-eq tx-sender (get creator project)) err-owner-only)
    
    (map-set project-updates
      { project-id: project-id, update-id: update-id }
      {
        description: description,
        impact-evidence: impact-evidence,
        timestamp: block-height,
        reporter: tx-sender
      }
    )
    
    (ok true)
  )
)

(define-public (verify-project (project-id uint) (impact-score uint))
  (let
    (
      (project (unwrap! (get-project project-id) err-project-not-found))
    )
    (asserts! (is-authorized-verifier tx-sender) err-unauthorized-verifier)
    (asserts! (<= impact-score u100) err-invalid-impact-score)
    
    (map-set projects
      { project-id: project-id }
      (merge project { 
        impact-score: impact-score,
        verified: true
      })
    )
    
    (ok true)
  )
)

(define-public (authorize-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set authorized-verifiers
      { verifier: verifier }
      { authorized: true }
    )
    
    (ok true)
  )
)

(define-public (revoke-verifier (verifier principal))
  (begin
    (asserts! (is-eq tx-sender contract-owner) err-owner-only)
    
    (map-set authorized-verifiers
      { verifier: verifier }
      { authorized: false }
    )
    
    (ok true)
  )
)

;; Initialize contract with owner as first authorized verifier
(map-set authorized-verifiers
  { verifier: contract-owner }
  { authorized: true }
)