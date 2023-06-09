module Evergreen.V18.Pages.Admin.ShowJson exposing (..)

import Evergreen.V18.BackupModel


type alias Model =
    { backup : Maybe String
    }


type Msg
    = BackupModelFromBackend Evergreen.V18.BackupModel.BackupModel
