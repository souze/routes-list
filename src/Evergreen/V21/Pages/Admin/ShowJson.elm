module Evergreen.V21.Pages.Admin.ShowJson exposing (..)

import Evergreen.V21.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V21.BackupModel.BackupModel
