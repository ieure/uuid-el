;;; uuid.el --- Minor mode for highlighting UUIDs    -*- lexical-binding: t; -*-

;; Copyright (C) 2014 Ian Eure

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

(defconst uuid-re
  "\\b[0-9a-f]\\{8\\}-[0-9a-f]\\{4\\}-[0-9a-f]\\{4\\}-[0-9a-f]\\{4\\}-[0-9a-f]\\{12\\}\\b")

(defgroup uuid nil "Highlighting of UUIDs"
  :group 'convenience)

(defface uuid-face
  '((t (:foreground "#2FADED")))
  "Face for highlighting UUIDs"
  :group 'uuid)

(defconst uuid-facedef
  `((,uuid-re 0 '(face uuid-face
                       uuid t
                       keymap uuid-mode-map)
              prepend)))

(defun uuid-save-uuid-at-point ()
  (interactive)
  (save-match-data
    (save-excursion
      (unless (looking-at uuid-re)
        (re-search-backwards uuid-re))
      (kill-ring-save (match-beginning 0) (match-end 0)))))

(defconst uuid-mode-map
  (easy-mmode-define-keymap '(("w" . uuid-save-uuid-at-point))))

(define-minor-mode uuid-mode "A mode for highlighting UUIDs"
  nil " UUID" nil
  (if uuid-mode
      (uuid-mode-enable)
    (uuid-mode-disable))
    (font-lock-flush)
    (font-lock-ensure))

(defun uuid-mode-enable ()
  (font-lock-add-keywords nil uuid-facedef))

(defun uuid-mode-disable ()
  (font-lock-remove-keywords nil uuid-facedef))

(defun uuid-next-uuid (&optional n)
  (interactive (list current-prefix-arg))
  (re-search-forward uuid-re nil t (or n 1)))

(defun uuid-previous-uuid (&optional n)
  (interactive (list current-prefix-arg))
  (re-search-backward uuid-re nil t (or n 1)))

(provide 'uuid)
;;; uuid.el ends here
