(setq gmat-keywords
      (let* (
             (flow-control '("If"
                             "For"
                             "While"
                             "BeginScript"
                             "Target"
                             "Optimize"
                             "Else"))

             (flow-ends '("EndIf"
                          "EndFor"
                          "EndWhile"
                          "EndScript"
                          "EndTarget"
                          "EndOptimize"))

             (objects '("Array"
                        "Barycenter"
                        "CoordinateSystem"
                        "DifferentialCorrector"
                        "EphemerisFile"
                        "FileInterface"
                        "FiniteBurn"
                        "FminconOptimizer"
                        "ForceModel"
                        "Formation"
                        "FuelTank"
                        "GroundStation"
                        "GroundTrackPlot"
                        "ImpulsiveBurn"
                        "LibrationPoint"
                        "MatlabFunction"
                        "OrbitView"
                        "Propagator"
                        "ReportFile"
                        "SolarSystem"
                        "Spacecraft"
                        "String"
                        "Thruster"
                        "Variable"
                        "VF13ad"
                        "XYPlot"
                        "Asteroid"
                        "Comet"
                        "Planet"
                        "Moon"))

             (functions '("Achieve"
                          "BeginMissionSequence"
                          "BeginFiniteBurn"
                          "BeginScript"
                          "CallMatlabFunction"
                          "ClearPlot"
                          "Create"
                          "EndFiniteBurn"
                          "For"
                          "If"
                          "GMAT"
                          "Maneuver"
                          "MarkPoint"
                          "NonlinearConstraint"
                          "Optimize"
                          "PenDown"
                          "PenUp"
                          "Propagate"
                          "Report"
                          "Set"
                          "Stop"
                          "Target"
                          "Toggle"
                          "Vary"
                          "While"))

             (misc '("Yukon"
                     "CommandEcho"
                     "Include"
                     "Write"
                     "BatchEstimatorInv"
                     "Simulator"
                     "ErrorModel"
                     "AcceptFilter"
                     "RejectFilter"
                     "TrackingDataSet"
                     "RunEstimator"
                     "RunSimulator"))

             (flow-control-regex (regexp-opt flow-control 'words))
             (flow-ends-regex (regexp-opt flow-ends 'words))
             (objects-regex (regexp-opt objects 'words))
             (functions-regex (regexp-opt functions 'words))
             (misc-regex (regexp-opt misc 'words))
             )                   ;TODO: Strings, comments
        `(
          (,flow-control-regex . font-lock-keyword-face)
          (,flow-ends-regex . font-lock-keyword-face)
          (,objects-regex . font-lock-type-face)
          (,misc-regex . font-lock-constant-face)
          (,functions-regex . font-lock-builtin-face)
          )))
(setq gmat-mode-syntax-table
      (let ( (synTable (make-syntax-table python-mode-syntax-table)))

        ;; set/modify each char's class
        (modify-syntax-entry ?% "<" synTable)
        (modify-syntax-entry ?\n ">" synTable)
                                        ;(modify-syntax-entry ?\' (string ?') synTable)
        ;; more lines here ...
        ;; return it
        synTable))

(defun gmat-indent-line ()
  "Indent current line as WPDL code."
  (interactive)
  (beginning-of-line)
  (if (bobp)
	  (indent-line-to 0)		   ; First line is always non-indented
	(let ((not-indented t) cur-indent)
	  (if (looking-at "^[ \t]*End.*") ; If the line we are looking at is the end of a block, then decrease the indentation
		  (progn
			(save-excursion
			  (forward-line -1)
			  (setq cur-indent (- (current-indentation) default-tab-width)))
			(if (< cur-indent 0) ; We can't indent past the left margin
				(setq cur-indent 0)))
		(save-excursion
		  (while not-indented ; Iterate backwards until we find an indentation hint
			(forward-line -1)
			(if (looking-at "^[ \t]*End.*") ; This hint indicates that we need to indent at the level of the END_ token
				(progn
				  (setq cur-indent (current-indentation))
				  (setq not-indented nil))
			  (if (looking-at "^[\t]*\\(BeginScript\\|Else\\|For\\|If\\|Optimize\\|Target\\|While\\)\\>") ; This hint indicates that we need to indent an extra level
				  (progn
					(setq cur-indent (+ (current-indentation) default-tab-width)) ; Do the actual indenting
					(setq not-indented nil))
				(if (bobp)
					(setq not-indented nil)))))))
	  (if cur-indent
		  (indent-line-to cur-indent)
		(indent-line-to 0))))) ; If we didn't see an indentation hint, then allow no indentation

;; (defun gmat-indent-line ()
;;   (interactive)
;;   (beginning-of-line)
;;   (if (bobp)  ; Check for rule 1
;;       (indent-line-to 0)
;;     )
;;   (let ((not-indented t) cur-indent)
;;     (if (looking-at "^[ \t]*End.*;") ; Check for rule 2 ;
;;         (progn
;;           (save-excursion
;;             (forward-line -1)
;;             (setq cur-indent (- (current-indentation) default-tab-width)))
;;           (if (< cur-indent 0)
;;               (setq cur-indent 0)))
;;       (save-excursion
;;         (while not-indented
;;           (forward-line -1)
;;           (if (looking-at "^[ \t]*End.*;") ; Check for rule 3
;;               (progn
;;                 (setq cur-indent (current-indentation))
;;                 (setq not-indented nil))
;;                                         ; Check for rule 4
;;             (if (looking-at "\\<\\(BeginScript\\|Else\\|For\\|If\\|Optimize\\|Target\\|While\\)\\>"
;;                 (progn
;;                   (setq cur-indent (+ (current-indentation) default-tab-width))
;;                   (setq not-indented nil))
;;               (if (bobp) ; Check for rule 5
;;                   (setq not-indented nil)))))))
;;     (if cur-indent
;;         (indent-line-to cur-indent)
;;       (indent-line-to 0)))) ; If we didn't see an indentation hint, then allow no indentation

;;;###autoload
          (define-derived-mode gmat-mode js-jsx-mode "gmat mode"
            "Major mode for editing GMATScript (General Mission Analysis Tool)"

            ;; code for syntax highlighting
            (set-syntax-table gmat-mode-syntax-table)
            (setq font-lock-defaults '((gmat-keywords))))

;;;###autoload
          (add-to-list 'auto-mode-alist '("\\.script\\'" . gmat-mode))


          (provide 'gmat-mode)
