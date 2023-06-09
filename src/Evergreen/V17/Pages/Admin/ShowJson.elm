module Evergreen.V17.Pages.Admin.ShowJson exposing (..)

import Evergreen.V17.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V17.BackupModel.BackupModel
