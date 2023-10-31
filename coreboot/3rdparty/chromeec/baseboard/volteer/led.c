/* Copyright 2019 The Chromium OS Authors. All rights reserved.
 * Use of this source code is governed by a BSD-style license that can be
 * found in the LICENSE file.
 *
 * Power and battery LED control for Volteer
 */

#include "common.h"
#include "ec_commands.h"
#include "led_common.h"
#include "led_pwm.h"

const enum ec_led_id supported_led_ids[] = {
	EC_LED_ID_BATTERY_LED,
};
const int supported_led_ids_count = ARRAY_SIZE(supported_led_ids);

struct pwm_led led_color_map[] = {
				/* Red, Green, Blue */
	[EC_LED_COLOR_RED] =    {  100,   0,     0 },
	[EC_LED_COLOR_GREEN] =  {    0, 100,     0 },
	[EC_LED_COLOR_BLUE] =   {    0,   0,   100 },
	[EC_LED_COLOR_YELLOW] = {  100, 100,     0 },
	[EC_LED_COLOR_WHITE] =  {  100, 100,   100 },
	[EC_LED_COLOR_AMBER] =  {  100,  75,     0 },
};

struct pwm_led pwm_leds[] = {
	/* 2 RGB diffusers controlled by 1 set of 3 channels. */
	[PWM_LED0] = {
		PWM_CH_LED3_RED,
		PWM_CH_LED2_GREEN,
		PWM_CH_LED1_BLUE,
	},
};

void led_get_brightness_range(enum ec_led_id led_id, uint8_t *brightness_range)
{
	/* TODO(b/139554899): Consider letting these go up to 255. */
	brightness_range[EC_LED_COLOR_RED] = 100;
	brightness_range[EC_LED_COLOR_GREEN] = 100;
	brightness_range[EC_LED_COLOR_BLUE] = 100;
}

int led_set_brightness(enum ec_led_id led_id, const uint8_t *brightness)
{
	enum pwm_led_id pwm_id;

	/* Convert ec_led_id to pwm_led_id. */
	if (led_id == EC_LED_ID_BATTERY_LED)
		pwm_id = PWM_LED0;
	else
		return EC_ERROR_UNKNOWN;

	if (brightness[EC_LED_COLOR_RED])
		set_pwm_led_color(pwm_id, EC_LED_COLOR_RED);
	else if (brightness[EC_LED_COLOR_GREEN])
		set_pwm_led_color(pwm_id, EC_LED_COLOR_GREEN);
	else if (brightness[EC_LED_COLOR_BLUE])
		set_pwm_led_color(pwm_id, EC_LED_COLOR_BLUE);
	else if (brightness[EC_LED_COLOR_YELLOW])
		set_pwm_led_color(pwm_id, EC_LED_COLOR_YELLOW);
	else if (brightness[EC_LED_COLOR_WHITE])
		set_pwm_led_color(pwm_id, EC_LED_COLOR_WHITE);
	else if (brightness[EC_LED_COLOR_AMBER])
		set_pwm_led_color(pwm_id, EC_LED_COLOR_AMBER);
	else
		/* Otherwise, the "color" is "off". */
		set_pwm_led_color(pwm_id, -1);

	return EC_SUCCESS;
}
