module SPS.App
  ( App (..)
  )
where

------------------------------------------------------------------------------
data AppError = AppError

------------------------------------------------------------------------------
newtype App a = App
  { unApp :: ReaderT Env (ExceptT AppError IO) a
  }
