/**
********************************************************************************
* @file
* @brief
*
********************************************************************************
* @attention
*
********************************************************************************
*/


/*--INCLUDES------------------------------------------------------------------*/
#include <string.h>
#include "bvr_name_task.h"
#include "BVR_error.h"
#include "BVR_log.h"

// #include "queue.h"
// #include "event_groups.h"
// #include "semphr.h"
// #include "stream_buffer.h"
// #include "message_buffer.h"


/******************************************************************************/
/*                      HANDLES DEFINITION                                    */
/******************************************************************************/

/*--TASK----------------------------------------------------------------------*/
/* Stack size */
#define NAME_TASK_STACK_W   (BVR_STACK_MEDIUM_W)
/* Priority */
#define NAME_TASK_PRIORITY      (BVR_PRIO_NORMAL)

TaskHandle_t   g_name_task_handle = NULL;
static StaticTask_t   s_name_task_tcb;
static StackType_t    s_name_task_stack[NAME_TASK_STACK_W];


/*--QUEUE---------------------------------------------------------------------*/

/*--TYPEDEF-------------------------------------------------------------------*/
// typedef struct
// {
//   uint32_t id;
//   uint32_t arg;
// } name_msg_t;

// #define NAME_Q_LEN        10
// #define NAME_Q_ITEM_SIZE  sizeof(name_msg_t)
// static const TickType_t NAME_Q_TIMEOUT = pdMS_TO_TICKS(100);

/* Handles here */
// static QueueHandle_t s_name_q_handle = NULL;
// static StaticQueue_t s_name_q_tcb;
// static uint8_t       s_name_q_storage_area[NAME_Q_LEN * NAME_Q_ITEM_SIZE];


/*--EVENT---------------------------------------------------------------------*/

// #define NAME_EVT_WORK   (1u << 0)
// static StaticEventGroup_t s_name_evt_tcb;
// static EventGroupHandle_t s_name_evt_handle = NULL;


/*--MUTEX---------------------------------------------------------------------*/
//
// static StaticSemaphore_t s_name_mtx_tcb;
// static SemaphoreHandle_t s_name_mtx_handle = NULL;

// static inline void name_lock(void)   { xSemaphoreTake(s_name_mtx_handle, portMAX_DELAY); }
// static inline void name_unlock(void) { xSemaphoreGive(s_name_mtx_handle); }


/*--TIMER---------------------------------------------------------------------*/

// static StaticTimer_t s_name_tm_tcb;
// static TimerHandle_t s_name_tm_handle = NULL;



/*--MESSAGE--BUFFERS----------------------------------------------------------*/

// #define NAME_MB_CAPACITY_BYTES   512u   /* includes per-message overhead (~4B/msg) */
//
// static StaticMessageBuffer_t s_name_mb_tcb;
// static uint8_t               s_name_mb_storage_area[NAME_MB_CAPACITY_BYTES];
// static MessageBufferHandle_t s_name_mb_handle = NULL;


/*--STREAM--BUFFERS-----------------------------------------------------------*/

// #define NAME_SB_CAPACITY_BYTES   512u
// #define NAME_SB_TRIGGER_BYTES     64u
//
// static StaticStreamBuffer_t s_name_sb_tcb;
// static uint8_t              s_name_sb_storage_area[NAME_SB_CAPACITY_BYTES];
// static StreamBufferHandle_t s_name_sb_handle = NULL;


/*--GLOBAL--CONSTANTS---------------------------------------------------------*/

/*--TASK----------------------------------------------------------------------*/
static const char *s_task_id = "Task Name";



/*--STATIC--DATA--------------------------------------------------------------*/

/*--TASK----------------------------------------------------------------------*/
static void bvr_name_task(void *pvParameters);


/*--CALLBACK--FUNCTION--------------------------------------------------------*/
// static void name_tm_cb(TimerHandle_t xTimer) { (void)xTimer; /* ... */ }



/*--PUBLIC--API---------------------------------------------------------------*/
void bvr_name_task_start(void)
{
    configASSERT(strlen(s_task_id) < configMAX_TASK_NAME_LEN);

    /* Create with static allocation only */
    g_name_task_handle = xTaskCreateStatic
    (
        bvr_name_task,
        s_task_id,                       /* task name (for trace/CLI) */
        NAME_TASK_STACK_W,            /* depth in words, not bytes */
        NULL,                          /* pvParameters */
        NAME_TASK_PRIORITY,            /* priority from header */
        s_name_task_stack,             /* stack storage */
        &s_name_task_tcb               /* TCB storage */
    );
    BVR_RTOS_CHECK(g_name_task_handle);

    BVR_LOGT(NULL, s_task_id, "SUCCESS: Task Created");
}



/*--QUEUE---------------------------------------------------------------------*/
// void bvr_name_q_start(void)
// {
//   s_name_q_handle = xQueueCreateStatic(NAME_Q_LEN,
//                                        NAME_Q_ITEM_SIZE,
//                                        s_name_q_storage_area,
//                                        &s_name_q_tcb);
//   BVR_RTOS_CHECK(s_name_q_handle);
//   BVR_LOGT(NULL, s_task_id, "SUCCESS: Queue Created");
// }


// BaseType_t bvr_name_post(uint32_t id, uint32_t arg, TickType_t to)
// {
//   name_msg_t m = { .id = id, .arg = arg };
//   return xQueueSend(s_name_q_handle, &m, to);
// }

// BaseType_t bvr_name_post_from_isr(uint32_t id, uint32_t arg, BaseType_t *hpw)
// {
//   name_msg_t m = { .id = id, .arg = arg };
//   return xQueueSendFromISR(s_name_q_handle, &m, hpw);
// }


/*--EVENT---------------------------------------------------------------------*/
// void bvr_name_evt_start(void)
// {
//   s_name_evt_handle = xEventGroupCreateStatic(&s_name_evt_tcb);
//   BVR_RTOS_CHECK(s_name_evt_handle);
//   BVR_LOGT(NULL, s_task_id, "SUCCESS: Event Created");
//   xEventGroupClearBits(s_name_evt_handle, 0xFFFFFFFFu);
// }

// void bvr_name_evt_set(EventBits_t bits)
// {
//   (void)xEventGroupSetBits(s_name_evt_handle, bits);
// }

// void bvr_name_evt_set_from_isr(EventBits_t bits, BaseType_t *hpw)
// {
//   (void)xEventGroupSetBitsFromISR(s_name_evt_handle, bits, hpw);
// }


/*--MUTEX---------------------------------------------------------------------*/
// void bvr_name_mtx_start(void)
// {
// s_name_mtx_handle = xSemaphoreCreateMutexStatic(&s_name_mtx_tcb);
// BVR_RTOS_CHECK(s_name_mtx_handle);
//   BVR_LOGT(NULL, s_task_id, "SUCCESS: Mutex Created");
// }


/*--TIMER---------------------------------------------------------------------*/
// void bvr_name_tm_start(void)
// {
  // s_name_tm_handle = xTimerCreateStatic("NAME/tm",
                       // pdMS_TO_TICKS(1000), pdTRUE, NULL, name_tm_cb, &s_name_tm_tcb);
  // BVR_RTOS_CHECK(s_name_tm_handle);
//   BVR_LOGT(NULL, s_task_id, "SUCCESS: Timer Created");
  // xTimerStart(s_name_tm_handle, 0);
// }


/*--MESSAGE--BUFFERS----------------------------------------------------------*/
// void bvr_name_msgbuf_start(void)
// {
//   s_name_mb_handle = xMessageBufferCreateStatic(
//       NAME_MB_CAPACITY_BYTES,
//       s_name_mb_storage_area,
//       &s_name_mb_tcb);
//   BVR_RTOS_CHECK(s_name_mb_handle);
//   BVR_LOGT(NULL, s_task_id, "SUCCESS: Message Buffer Created");
// }


/* Send a message (task context) */
// static size_t name_msg_send(const void *msg, size_t len, TickType_t to)
// {
//   return xMessageBufferSend(s_name_mb_handle, msg, len, to);
// }

/* Send a message (ISR context) */
// static size_t name_msg_send_from_isr(const void *msg, size_t len, BaseType_t *hpw)
// {
//   return xMessageBufferSendFromISR(s_name_mb_handle, msg, len, hpw);
// }

/* Receive a whole message (task context) */
// static size_t name_msg_recv(void *dst, size_t max, TickType_t to)
// {
//   return xMessageBufferReceive(s_name_mb_handle, dst, max, to);
// }


/*--STREAM--BUFFERS-----------------------------------------------------------*/
// void bvr_name_stream_start(void)
// {
//   s_name_sb_handle = xStreamBufferCreateStatic(
//       NAME_SB_CAPACITY_BYTES,
//       NAME_SB_TRIGGER_BYTES,           /* wake reader when >= this many bytes */
//       s_name_sb_storage_area,
//       &s_name_sb_tcb);
//   BVR_RTOS_CHECK(s_name_sb_handle);
//   BVR_LOGT(NULL, s_task_id, "SUCCESS: Stream Buffer Created");
// }

/* Writer API (task context) */
// static size_t name_stream_write(const void *src, size_t len, TickType_t to)
// {
//   return xStreamBufferSend(s_name_sb_handle, src, len, to);
// }

/* Writer API (ISR context) */
// static size_t name_stream_write_from_isr(const void *src, size_t len, BaseType_t *hpw)
// {
//   return xStreamBufferSendFromISR(s_name_sb_handle, src, len, hpw);
// }

/* Reader (in your task loop) */
// static size_t name_stream_read(void *dst, size_t max, TickType_t to)
// {
//   return xStreamBufferReceive(s_name_sb_handle, dst, max, to);
// }



/******************************************************************************/
/*                             TASK ENTRY                                     */
/******************************************************************************/
static void bvr_name_task(void *pvParameters)
{
  (void)pvParameters;

  /* Capture scheduler tick at task start */
  const TickType_t t0 = xTaskGetTickCount();
  /* Convert to milliseconds */
  const uint32_t t0_ms = (uint32_t)(t0 * portTICK_PERIOD_MS);

  UBaseType_t hw = uxTaskGetStackHighWaterMark(NULL);

  BVR_LOGDF(RTOS, s_task_id,
             "Task Started: \t(tick=%lu, ~%lums since boot)",
             (unsigned long)t0, (unsigned long)t0_ms);

  BVR_LOGDF(s_task_id, "HWM=%lu words (~%lu B free)",
            (unsigned long)hw, (unsigned long)hw * 4ul);



  for(;;)
  {
    /* TODO: */
    /* Replace with xQueueReceive/xEventGroupWaitBits/vTaskDelay as needed. */


  }

}

/******************************************************************************/
/*                             END OF FILE                                    */
/******************************************************************************/
