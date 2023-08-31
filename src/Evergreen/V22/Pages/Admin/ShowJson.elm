module Evergreen.V22.Pages.Admin.ShowJson exposing (..)

import Evergreen.V22.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V22.BackupModel.BackupModel
