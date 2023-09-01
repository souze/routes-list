module Evergreen.V25.Pages.Admin.ShowJson exposing (..)

import Evergreen.V25.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V25.BackupModel.BackupModel
