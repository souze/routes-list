module Evergreen.V26.Pages.Admin.ShowJson exposing (..)

import Evergreen.V26.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V26.BackupModel.BackupModel
