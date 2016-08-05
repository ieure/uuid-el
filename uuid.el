;;; uuid.el --- Minor mode for highlighting UUIDs    -*- lexical-binding: t; -*-

;; Copyright (C) 2014, 2016 Ian Eure

;; Author: Ian Eure <ian.eure@gmail.com>
;; Keywords: convenience

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defconst uuid-anyhex "[0-9a-fA-F]")

(defconst uuid-unknown-type-re
  (concat "\\b" uuid-anyhex "\\{8\\}-" uuid-anyhex "\\{4\\}-"
          uuid-anyhex "\\{4\\}-" uuid-anyhex "\\{4\\}-" uuid-anyhex
          "\\{12\\}\\b"))

(defconst uuid-type1-re
  (concat "\\b" uuid-anyhex "\\{8\\}-" uuid-anyhex "\\{4\\}-1" uuid-anyhex "\\{3\\}-"
          uuid-anyhex "\\{4\\}-" uuid-anyhex "\\{12\\}\\b"))

(defconst uuid-type2-re
  (concat "\\b" uuid-anyhex "\\{8\\}-" uuid-anyhex "\\{4\\}-2"
          uuid-anyhex "\\{3\\}-" uuid-anyhex" \\{4\\}-" uuid-anyhex
          "\\{12\\}\\b"))

(defconst uuid-type3-re
  (concat "\\b" uuid-anyhex "\\{8\\}-" uuid-anyhex "\\{4\\}-3"
          uuid-anyhex "\\{3\\}-" uuid-anyhex "\\{4\\}-" uuid-anyhex
          "\\{12\\}\\b"))

(defconst uuid-type4-re
  (concat "\\b" uuid-anyhex "\\{8\\}-" uuid-anyhex "\\{4\\}-4"
          uuid-anyhex "\\{3\\}-[89ABab]" uuid-anyhex "\\{3\\}-" uuid-anyhex
          "\\{12\\}\\b"))

(defconst uuid-type5-re
  (concat "\\b" uuid-anyhex "\\{8\\}-" uuid-anyhex "\\{4\\}-5"
          uuid-anyhex "\\{3\\}-" uuid-anyhex "\\{4\\}-" uuid-anyhex
          "\\{12\\}\\b"))

(defconst uuid-empty-uuid "\\bd41d8cd9-8f00-3204-a980-0998ecf8427e\\b")

(defgroup uuid nil "Highlighting of UUIDs"
  :group 'convenience)

(defface uuid-type1-face
  '((t (:foreground "#2FADED")))
  "Face for highlighting Type 1 (timestamp) UUIDs"
  :group 'uuid)

(defface uuid-type1-empty-face
  '((t (:foreground "#FF0000")))
  "Face for highlighting empty Type 1 (MD5) UUIDs.

This is the UUID of an empty input. It's displayed specially, this is
often a sign of a problem with whatever generated it."
  :group 'uuid)

(defface uuid-type2-face
  '((t (:foreground "#2FADED")))
  "Face for highlighting Type 2 (DCE) UUIDs"
  :group 'uuid)

(defface uuid-type3-face
  '((t (:foreground "#2FADED")))
  "Face for highlighting Type 3 (MD5) UUIDs"
  :group 'uuid)

(defface uuid-type4-face
  '((t (:foreground "#2FADED")))
  "Face for highlighting Type 4 (random) UUIDs"
  :group 'uuid)

(defface uuid-type5-face
  '((t (:foreground "#2FADED")))
  "Face for highlighting Type 5 (SHA) UUIDs"
  :group 'uuid)

(defface uuid-unknown-type-face
  '((t (:foreground "#FF0000")
       (:slant 'italic)))
  "Face for highlighting invalid UUIDs.

   This is a UUID which looks valid, but lacks the internal structure
   defined by RFC 4122."
  :group 'uuid)

(defconst uuid-font-lock-keywords
  `((,uuid-type1-re 0 '(face uuid-type1-face
                             uuid t
                             keymap uuid-mode-map))
    (,uuid-empty-uuid 0 '(face uuid-type1-empty-face
                             uuid t
                             keymap uuid-mode-map))
    (,uuid-type2-re 0 '(face uuid-type1-face
                             uuid t
                             keymap uuid-mode-map))

    (,uuid-type3-re 0 '(face uuid-type1-face
                             uuid t
                             keymap uuid-mode-map))
    (,uuid-type4-re 0 '(face uuid-type1-face
                             uuid t
                             keymap uuid-mode-map))
    (,uuid-type5-re 0 '(face uuid-type1-face
                             uuid t
                             keymap uuid-mode-map))
    (,uuid-unknown-type-re 0 '(face uuid-unknown-type face
                                    uuid t
                                    keymap uuid-mode-map))))

(defun uuid-save-uuid-at-point ()
  (interactive)
  (kill-new (thing-at-point 'uuid t)))

(defconst uuid-mode-map
  (easy-mmode-define-keymap '(("w" . uuid-save-uuid-at-point))))

(define-minor-mode uuid-mode "A mode for highlighting UUIDs"
  nil nil nil
  (if uuid-mode
      (uuid-mode-enable)
    (uuid-mode-disable))

  (font-lock-fontify-buffer))

(defun uuid-mode-enable ()
  (font-lock-add-keywords nil uuid-font-lock-keywords))

(defun uuid-mode-disable ()
  (font-lock-remove-keywords nil uuid-font-lock-keywords))

(defun forward-uuid (&optional n)
  (interactive (list current-prefix-arg))
  (re-search-forward uuid-re nil t (or n 1)))

(defun backward-uuid (&optional n)
  (interactive (list current-prefix-arg))
  (re-search-backward uuid-re nil t (or n 1)))

(put 'uuid 'bounds-of-thing-at-point
     (lambda ()
       (let ((thing (thing-at-point-looking-at
                     uuid-re 500)))
         (when thing
           (cons (match-beginning 0) (match-end 0))))))

(provide 'uuid)
;;; uuid.el ends here
