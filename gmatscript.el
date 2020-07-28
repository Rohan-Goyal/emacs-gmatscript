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
             )                   ; Generates regexes to match these wordlists
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
        (modify-syntax-entry ?\n ">" synTable) ; Modifies the comment syntax
                                        ;(modify-syntax-entry ?\' (string ?') synTable)
        synTable))


;;;###autoload
          (define-derived-mode gmat-mode js-jsx-mode "gmat mode"
            "Major mode for editing GMATScript (General Mission Analysis Tool)"

            ;; code for syntax highlighting
            (set-syntax-table gmat-mode-syntax-table)
            (setq font-lock-defaults '((gmat-keywords))))

;;;###autoload
          (add-to-list 'auto-mode-alist '("\\.script\\'" . gmat-mode))
          (provide 'gmat-mode)
