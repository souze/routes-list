module Evergreen.V7.Pages.Admin.ShowJson exposing (..)

import Evergreen.V7.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V7.BackupModel.BackupModel
