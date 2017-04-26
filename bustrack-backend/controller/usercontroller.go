package controller

import (
	"bustrack/dbs"
	"bustrack/models"
	"bustrack/tools"
	"fmt"
	"net/http"
	"strconv"

	"github.com/labstack/echo"
	_ "github.com/lib/pq" //for postgres driver
)

// CreateUser create user
func CreateUser(c echo.Context) (err error) {
	user := &models.Users{
		Email:    c.FormValue("email"),
		Password: c.FormValue("password"),
		Orgid:    stringtoInt(c.FormValue("orgid")),
	}

	if err = c.Bind(user); err != nil {
		return err
	}
	// db := dbs.GetDB()
	result, err := models.InsertUser(dbs.DB, user)
	tools.PanicIf(err)
	fmt.Println(result)
	// dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusCreated, "User is created")
	}
	return c.JSON(http.StatusNotFound, "User is not created")
}

//DeleteUser delete the user by id
func DeleteUser(c echo.Context) (err error) {
	// db := dbs.GetDB()
	result, err := models.DeleteUser(dbs.DB, stringtoInt(c.Param("userid")))
	tools.PanicIf(err)
	fmt.Println(result)
	//dbs.CloseDB(db)
	if result != nil {
		return c.JSON(http.StatusOK, "Deleted")
	}
	return c.JSON(http.StatusNotFound, "Not Deleted")
}

//GetUser get the vendor by id
func GetUser(c echo.Context) (err error) {
	//	db := dbs.GetDB()
	result, err := models.GetUsers(dbs.DB, stringtoInt(c.Param("userid")))
	tools.PanicIf(err)
	usrs := make([]models.Users, 0.0)
	usr := models.Users{}
	for result.Next() {
		result.Scan(&usr.Userid, &usr.Email, &usr.Password, &usr.Orgid)
		fmt.Println(usr.Userid, usr.Email, usr.Password, usr.Orgid)
		usrs = append(usrs, usr)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, usrs)
}

//GetUserOrg get user organization
func GetUserOrg(c echo.Context) (err error) {
	result, err := models.GetUserOrg(dbs.DB, stringtoInt(c.QueryParam("orgid")), stringtoInt(c.QueryParam("userid")))
	tools.PanicIf(err)
	usrs := make([]models.Users, 0.0)
	usr := models.Users{}
	for result.Next() {
		result.Scan(&usr.Userid, &usr.Email, &usr.Password, &usr.Orgid)
		fmt.Println(usr.Userid, usr.Email, usr.Password, usr.Orgid)
		usrs = append(usrs, usr)
	}
	//	dbs.CloseDB(db)
	return c.JSON(http.StatusOK, usrs)
}

//UpdateUser update the vendor by id
func UpdateUser(c echo.Context) (err error) {
	user := &models.Users{
		Userid:   stringtoInt(c.FormValue("userid")),
		Email:    c.FormValue("email"),
		Password: c.FormValue("password"),
		Orgid:    stringtoInt(c.FormValue("orgid")),
	}
	if err = c.Bind(user); err != nil {
		return err
	}
	orm := map[string]string{
		"email":           user.Email,
		"password":        user.Password,
		"organization_id": strconv.Itoa(user.Orgid),
	}
	query := tools.UpdateBuilder("users", orm, "user_id", strconv.Itoa(user.Userid))
	//db := dbs.GetDB()
	result, err := models.UpdateUsers(dbs.DB, query)
	if err != nil {
		fmt.Println("Error is", err)
	}
	//tools.PanicIf(err)
	//dbs.CloseDB(db)
	fmt.Println("result:", result)
	if result != nil {
		return c.JSON(http.StatusOK, "updated")
	}
	return c.JSON(http.StatusNotFound, "Not updated")
}
