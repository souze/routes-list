module Evergreen.V23.Pages.Admin.ShowJson exposing (..)

import Evergreen.V23.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V23.BackupModel.BackupModel
