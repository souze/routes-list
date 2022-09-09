module Evergreen.V6.Pages.Admin.ShowJson exposing (..)

import Evergreen.V6.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V6.BackupModel.BackupModel
