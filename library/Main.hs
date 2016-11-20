{-# LANGUAGE OverloadedStrings, QuasiQuotes,
             TemplateHaskell #-}
import Foundation
import Application () -- for YesodDispatch instance
import Yesod
import Yesod.Static
import Control.Monad.Logger (runStdoutLoggingT)
import Database.Persist.Postgresql

connStr :: ConnectionString
connStr = "dbname=d1uk2jbsb1rnr5 host=ec2-54-235-254-199.compute-1.amazonaws.com user=rjevziktnryrug password=ySddEKa--qHMP_CiA_2bG7-Y6H port=5432"

main::IO()
main = runStdoutLoggingT $ withPostgresqlPool connStr 10 $ \pool -> liftIO $ do 
       runSqlPersistMPool (runMigration migrateAll) pool 
       static@(Static settings) <- static "static"
       warp 8080 (App static pool)
       